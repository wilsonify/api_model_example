#!/usr/bin/env python3

import connexion
import os
import pickle
from swagger_server import encoder


def main():
    global house_price_model
    abspath_current = os.path.abspath(__file__)
    dname_current = os.path.dirname(abspath_current)
    pickle_path = os.path.join(dname_current, "house_price_model")
    with open(pickle_path, 'rb') as handle:
        house_price_model = (pickle.load(handle))

    app = connexion.App(__name__, specification_dir='./swagger/')
    app.app.json_encoder = encoder.JSONEncoder
    app.add_api('swagger.yaml', arguments={'title': 'Boston Housing Price'})
    app.run(port=8080)


if __name__ == '__main__':
    main()
