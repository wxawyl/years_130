from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import json

app = Flask(__name__)
CORS(app)

# 百度API配置
BAIDU_API_KEY = 'LgWIPzFEDuDVambLXHS5P2DT'
BAIDU_SECRET_KEY = 'plC6aLFLgSUiW7no8W58UOrU9DEqCtkl'

# 获取access_token的URL
TOKEN_URL = 'https://aip.baidubce.com/oauth/2.0/token'

# 菜品识别URL
DISH_RECOGNIZE_URL = 'https://aip.baidubce.com/rest/2.0/image-classify/v2/dish'

# 缓存access_token，避免频繁请求
cached_token = None
cached_token_expiry = 0


def get_access_token():
    """获取百度API的access_token"""
    global cached_token, cached_token_expiry
    import time
    
    # 如果token还没过期，直接返回
    if cached_token and time.time() < cached_token_expiry:
        return cached_token
    
    # 请求新的token
    params = {
        'grant_type': 'client_credentials',
        'client_id': BAIDU_API_KEY,
        'client_secret': BAIDU_SECRET_KEY
    }
    
    try:
        response = requests.get(TOKEN_URL, params=params)
        result = response.json()
        
        if 'access_token' in result:
            cached_token = result['access_token']
            # 设置过期时间，提前10分钟过期
            expires_in = result.get('expires_in', 2592000)
            cached_token_expiry = time.time() + expires_in - 600
            return cached_token
        else:
            print(f"获取token失败: {result}")
            return None
    except Exception as e:
        print(f"获取token异常: {e}")
        return None


@app.route('/api/health', methods=['GET'])
def health_check():
    """健康检查接口"""
    return jsonify({'status': 'ok', 'message': '后端服务运行正常'})


@app.route('/api/recognize-dish', methods=['POST'])
def recognize_dish():
    """菜品识别接口"""
    try:
        data = request.json
        
        if not data or 'image' not in data:
            return jsonify({
                'result_num': 0,
                'results': [],
                'error_code': 1001,
                'error_msg': '缺少图片数据'
            }), 400
        
        image_base64 = data['image']
        top_num = data.get('top_num', 5)
        filter_threshold = data.get('filter_threshold', 0.8)
        
        # 获取access_token
        access_token = get_access_token()
        if not access_token:
            return jsonify({
                'result_num': 0,
                'results': [],
                'error_code': 1002,
                'error_msg': '无法获取访问令牌'
            }), 500
        
        # 调用百度API
        api_url = f"{DISH_RECOGNIZE_URL}?access_token={access_token}"
        
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
        
        payload = {
            'image': image_base64,
            'top_num': str(top_num),
            'filter_threshold': str(filter_threshold)
        }
        
        response = requests.post(api_url, headers=headers, data=payload)
        
        # 直接返回百度API的结果
        return jsonify(response.json())
        
    except Exception as e:
        print(f"识别异常: {e}")
        return jsonify({
            'result_num': 0,
            'results': [],
            'error_code': 1003,
            'error_msg': f'识别服务异常: {str(e)}'
        }), 500


if __name__ == '__main__':
    print("启动健康管理应用后端服务...")
    print("API端点:")
    print("  - GET /api/health  健康检查")
    print("  - POST /api/recognize-dish  菜品识别")
    print("")
    app.run(host='0.0.0.0', port=5000, debug=True)
