#main.py
from Database.db import *
from flask import Flask, render_template, request, Response,jsonify
from waitress import serve
import datetime
import settings
import logging

app = Flask(__name__)

db = None
logger = logging.getLogger()

@app.route('/', methods=['GET'])
def index():
    return jsonify({'Message': 'Nice'})


@app.route('/', methods=['POST'])
def save_vote():
    # Get the team and time the vote was cast.
    team = request.form['team']
    time_cast = datetime.datetime.utcnow()
    # Verify that the team is one of the allowed options
    if team != "TABS" and team != "SPACES":
        logger.warning(team)
        return Response(
            response="Invalid team specified.",
            status=400
        )

    # [START cloud_sql_postgres_sqlalchemy_connection]
    # Preparing a statement before hand can help protect against injections.
    stmt = sqlalchemy.text(
        "INSERT INTO votes (time_cast, candidate)"
        " VALUES (:time_cast, :candidate)"
    )
    try:
        with db.connect() as conn:
            conn.execute(stmt, time_cast=time_cast, candidate=team)
    except Exception as e:
        logger.exception(e)
        return Response(
            status=500,
            response="Unable to successfully cast vote! Please check the "
                     "application logs for more details."
        )

    return Response(
        status=200,
        response="Vote successfully cast for '{}' at time {}!".format(
            team, time_cast)
    )



if __name__ == '__main__':
    app.run(port = os.environ["PORT"],debug=True)
    #print("Server on port",5000)
    #serve(app, port= 5000)
