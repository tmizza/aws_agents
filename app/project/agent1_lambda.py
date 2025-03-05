import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        input_text = event.get("input", "").lower()
        if "hello" in input_text:
            return {"response": "world"}
        else:
            logger.error(f"Invalid input: {input_text}")
            return {"error": "Invalid input"}
    except Exception as e:
        logger.error(f"Error in Agent1 Lambda: {e}")
        return {"error": "Internal Server Error"}
