# alpine version - light weight version of linux, ideal for running docker containers, 
FROM python:3.9-alpine3.13 
# specify whoever will be maintaining docker image
LABEL maintainer="kevinpham"

# recommended when running python in docker container, output of python will output to console
ENV PYTHONUNBUFFERED 1

# copy requirements file from local machine to docker image to install python requirements
COPY ./requirements.txt /tmp/requirements.txt
# directory that contains our project app
COPY ./app /app
# default directory when we run commands from
WORKDIR /app
# expose port 8000 to be accessible from container
EXPOSE 8000

# creates virtual environment to store dependencies 
# upgrade pip in venv
# install requirements.txt in venv
# remove tmp directory (to keep docker image as lightweight as possible)
# add new user inside image (best practice not to use root user)
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \ 
        django-user

# update path enviroment variable to venv, when we run commands it will automatically run from venv
ENV PATH="/py/bin:$PATH"

# specify the user we're switching to, previous lines are run with root user
USER django-user