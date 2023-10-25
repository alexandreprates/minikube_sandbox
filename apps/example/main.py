from typing import Union
import os

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/healthcheck")
def read_root():
    return {"status": "live"}


@app.get("/boom")
def read_root():
    os._exit(1)
    return {"never": "called"}

