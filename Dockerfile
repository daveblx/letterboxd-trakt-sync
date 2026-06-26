FROM python:3.13-alpine

WORKDIR /app

RUN apk update && \
    apk add git

ENV IN_DOCKER=true
ENV SCHEDULED=true

COPY . .

# install requirements
RUN pip install --no-cache-dir -r requirements.txt

# force-reinstall letterboxdpy from the custom fork to ensure the latest version is used
RUN pip install --force-reinstall --break-system-packages "git+https://github.com/f0e/letterboxdpy"

CMD ["python", "-u", "-m", "letterboxd_trakt.main"]
