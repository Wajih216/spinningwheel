from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, timedelta

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////data/user/0/com.example.spinningwheel/app_flutter/auth.db'
db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'users'
    usrId = db.Column(db.Integer, primary_key=True)
    fullName = db.Column(db.String(255))
    email = db.Column(db.String(255))
    usrName = db.Column(db.String(255), unique=True)
    usrPassword = db.Column(db.String(255))
    phoneNumber = db.Column(db.String(255), unique=True)
    prize = db.Column(db.Float, default=0.0)

class Winnings(db.Model):
    __tablename__ = 'winnings'
    id = db.Column(db.Integer, primary_key=True)
    usrId = db.Column(db.Integer)
    amount = db.Column(db.Float)
    date = db.Column(db.String(255))
    description = db.Column(db.String(255))

@app.route('/winners', methods=['GET'])
def get_daily_winners():
    today = datetime.now()
    yesterday = today - timedelta(days=1)
    winners = Winnings.query.filter(Winnings.date >= yesterday.strftime('%Y-%m-%d')).all()
    return jsonify([{'user_id': winner.usrId, 'amount': winner.amount, 'date': winner.date, 'description': winner.description} for winner in winners])

if __name__ == '__main__':
    app.run(debug=True)
