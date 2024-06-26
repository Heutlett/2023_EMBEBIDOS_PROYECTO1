from flask import Flask
from flask import json, jsonify
from flask import request, send_file
from flask_cors import CORS

from config import server_config as sconf
from config.constants import *

from controllers import webcam
from controllers import doors
from controllers import lights


# Creating an basic app
app = Flask(__name__)
app.config['DEBUG'] = True
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


@app.route('/', methods=['GET'])
def home():
    """
    This function returns a message for the basic API route.
    """
    return f'<h1>Smart Home API</h1><p>Welcome to the API.</p>'


@app.route('/login', methods=['POST'])
def login() -> json:
    """
    This function is used to login in the smart home app.

    It receives a body with the username and password.
    """
    # Generic response
    response = {
        'error': False,
        'data': None,
        'msg': None
    }

    # Validate response of the DB
    if request.json['username'] == "admin" and request.json['password'] == '123456':
        response['data'] = { 'valid': True }
    else:
        response['data'] = {
            'valid': False,
            'msg': 'Invalid username or password.'
        }
    return jsonify(response)

@app.route('/home/change_light_state', methods=['POST'])
def change_light_state():
    """
    This function is used to turn on and turn down a specific light in the house.
    """
    # Get params
    body = request.json
    room = body['room']
    state = body['state']

    # Generic response
    response = {
        'error': False,
        'data': None,
        'msg': None
    }

    # Check if the pin is valid
    if (room not in PINS['rooms']):
        response['error'] = True
        response['msg'] = '{room} not found.'
    # Check if the state is valid
    elif state not in [0, 1]:
        response['error'] = True
        response['msg'] = 'Unrecognized state.'
    else:
        # Turn on the light
        if state == HIGH:
            # Check if the light was turned on
            if lights.turn_on_light(room) != FAIL:
                response['msg'] = f'{room} light turned on.'
            else:
                response['msg'] = f'{room} light couldn\'t be turned on.'
        # Turn off the light
        else:
            # Check if the light was turned off
            if lights.turn_off_light(room) != FAIL:
                response['msg'] = f'{room} light turned off.'
            else:
                response['msg'] = f'{room} light couldn\'t be turned off.'

    return jsonify(response)

@app.route('/home/get_light_state', methods=['POST'])
def get_light_state():
    """
    This function is used to get a light state.
    """
    # Get params
    body = request.json
    room = body['room']

    # Generic response
    response = {
        'error': False,
        'data': None,
        'msg': None
    }

    # Check if the pin is valid
    if (room not in PINS['rooms']):
        response['error'] = True
        response['msg'] = '{room} not found.'
    else:
        response['data'] = {
            'state': lights.get_state(room)
        }

    return jsonify(response)

@app.route('/home/get_door_state', methods=['POST'])
def get_door_state():
    """
    This function is used to get a door state.
    """
    # Get params
    body = request.json
    room = body['door']

    # Generic response
    response = {
        'error': False,
        'data': None,
        'msg': None
    }

    # Check if the pin is valid
    if (room not in PINS['doors']):
        response['error'] = True
        response['msg'] = '{room} not found.'
    else:
        response['data'] = {
            'state': doors.get_state(room)
        }

    return jsonify(response)


@app.route('/home/take_photo', methods=['GET'])
def take_photo():
    """
    This function is used to take a photo of a room.
    """
    img_path = webcam.take_photo()

    return send_file(img_path)


if __name__ == '__main__':
    lights.start()
    doors.start()
    app.run(host=sconf.HOST, port=sconf.PORT)

