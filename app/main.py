from flask import Flask, jsonify
import os
import time
import redis

ENV = os.environ["APP_ENV"]
REDIS_URL = os.environ["REDIS_URL"]
app = Flask(__name__)
redis_client = redis.from_url(
    REDIS_URL,
    socket_connect_timeout=1,
    socket_timeout=1,
)


def redis_ok():
    try:
        return bool(redis_client.ping())
    except Exception:
        return False


@app.route("/api/")
def index():
    if not redis_ok():
        return jsonify({"message": "Hello", "env": ENV, "cache": "down"}), 503
    time.sleep(0.2)
    return jsonify({"message": "Hello", "env": ENV, "cache": "ok"})


@app.route("/api/health")
def health():
    return jsonify({"status": "OK"})


@app.route("/api/ready")
def ready():
    if redis_ok():
        return jsonify({"status": "READY"})
    return jsonify({"status": "NOT_READY"}), 503


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
