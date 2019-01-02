import os
import connexion
import pandas as pd
import pickle
import json
import sklearn
import six

from swagger_server.models.input import Input  # noqa: E501
from swagger_server import util


def predict_post(body):  # noqa: E501
    """make a prediction

    uses a pickled model # noqa: E501

    :param body: 
    :type body: dict | bytes

    :rtype: None
    """


    if connexion.request.is_json:
        body = connexion.request.get_json()  # noqa: E501

    df = pd.DataFrame.from_records(body)
    pred = house_price_model.predict(df[['age']])
    pred = pd.DataFrame(pred, columns=['predicted_price'])
    pred = pd.concat([df, pred], axis=1)
    return pred.to_json(index=False, orient='split')
