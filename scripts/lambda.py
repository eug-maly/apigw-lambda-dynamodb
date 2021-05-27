import json
import logging
import os
import boto3
import random
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_random_item(table):
    dynamodb = boto3.client('dynamodb')

    try:
        response = dynamodb.scan(TableName=table)
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        items = random.choice(response['Items'])
        item = items['word']['S']
        return item

def handle_connection(connection_id):
    status_code = 200
    try:
        logger.info(
            "Handling connection %s.", connection_id)
    except ClientError:
        logger.exception(
            "Couldn't handle connection %s.", connection_id)
        status_code = 503
    return status_code


def handle_message(connection_id, apig_management_client):
    status_code = 200
    try:
        logger.info("Got connection_id %s.", connection_id)
    except ClientError:
        logger.exception("Couldn't find connection_id. Using %s.", connection_id)

    message = get_random_item('word')
    logger.info("Message: %s", message)

    try:
        send_response = apig_management_client.post_to_connection(
                    Data=message, ConnectionId=connection_id)
        logger.info(
                    "Posted message to connection %s, got response %s.",
                    connection_id, send_response)
    except ClientError:
        logger.exception("Couldn't post to connection %s.", connection_id)
    except apig_management_client.exceptions.GoneException:
        logger.info("Connection %s is gone, removing.", connection_id)

    return status_code

def lambda_handler(event, context):
    """Handle requests."""
    route_key = event.get('requestContext', {}).get('routeKey')
    connection_id = event.get('requestContext', {}).get('connectionId')
    if route_key is None or connection_id is None:
        return {'statusCode': 400}
    logger.info("Request: %s, use connection_id %s.", route_key, connection_id)

    response = {'statusCode': 200}

    if route_key == '$connect' or route_key == '$disconnect':
        response['statusCode'] = handle_connection(connection_id)
    elif route_key == '$default':
        domain = event.get('requestContext', {}).get('domainName')
        stage = event.get('requestContext', {}).get('stage')
        if domain is None or stage is None:
            logger.warning(
                "Couldn't send message. Bad endpoint in request: domain '%s', "
                "stage '%s'", domain, stage)
            response['statusCode'] = 400
        else:
            apig_management_client = boto3.client(
                'apigatewaymanagementapi', endpoint_url=f'https://{domain}/{stage}')
            response['statusCode'] = handle_message(connection_id, apig_management_client)
    else:
        response['statusCode'] = 404

    return response
