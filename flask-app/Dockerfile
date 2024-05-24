FROM python
WORKDIR /app
RUN pip install flask
COPY hello.py .
CMD FLASK_APP=hello flask run --host=0.0.0.0

