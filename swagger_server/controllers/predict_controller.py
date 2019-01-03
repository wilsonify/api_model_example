import os
import connexion
import pandas as pd
import pickle
import json
import sklearn
import six

from swagger_server.models.input import Input  # noqa: E501
from swagger_server import util

abspath_current = os.path.abspath(__file__)
dname_current = os.path.dirname(abspath_current)
pickle_path = os.path.join(dname_current, "house_price_model")
with open(pickle_path, 'rb') as handle:
    house_price_model = (pickle.load(handle))


def predict_post(body):  # noqa: E501
    """make a prediction

    uses a pickled model # noqa: E501

    :param body: 
    :type body: dict | bytes

    :rtype: None
    """

    if connexion.request.is_json:
        body = connexion.request.get_json()  # noqa: E501

    df = pd.DataFrame(body, index=range(len(body) - 1))
    pred = house_price_model.predict(df[['age']])
    pred = pd.DataFrame(pred, columns=['predicted_price'])
    pred = pd.concat([df, pred], axis=1)
    return pred.to_json(index=False, orient='split')
