# Using flask to make an api 
# import necessary libraries and functions
from flask import Flask, Response, request
import os
import socket
import time
import hashlib
  
# creating a Flask app 
app = Flask(__name__) 
  
app.debug = os.environ.get("DEBUG", "").lower().startswith('y')

hostname = socket.gethostname()

# on the terminal type: curl http://127.0.0.1:80/ 
# returns hello world when we use GET. 
# returns the data that we send when we use POST. 
@app.route('/', methods = ['POST']) 
def index():
    if(request.method == 'POST'):
        data = request.form.get('data')
        if (data is not None):
            result = hashlib.md5(data.encode())
            time.sleep(0.1)
            return Response(str(result.hexdigest()),content_type="text/plain")
    return Response(str(hashlib.md5("NONE".encode()).hexdigest()),content_type="text/plain")
  
# A simple function to calculate the square of a number 
# the number to be squared is sent in the URL when we use GET 
# on the terminal type: curl http://127.0.0.1:80/ 
# this returns 100 (square of 10) 
@app.route('/', methods = ['GET']) 
def disp():  
    return "HASHER running on {}\n".format(hostname)
  
  
# driver function 
if __name__ == '__main__': 
    app.run(host="0.0.0.0", port=80)
