# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from swagger_server.models.input import Input  # noqa: E501
from swagger_server.test import BaseTestCase


class TestPredictController(BaseTestCase):
    """PredictController integration test stubs"""

    def test_predict_post(self):
        """Test case for predict_post

        make a prediction
        """
        body = Input()
        response = self.client.open(
            '/v2/predict',
            method='POST',
            data=json.dumps(body),
            content_type='application/json')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
