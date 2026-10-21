FROM python:3.12-slim-bookworm

ARG WITH_OCR=0

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HOME=/tmp

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg ca-certificates \
    && if [ "$WITH_OCR" = "1" ]; then \
        apt-get install -y --no-install-recommends tesseract-ocr libglib2.0-0; \
    fi \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/condensearr
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt \
    && if [ "$WITH_OCR" = "1" ]; then \
        pip install --no-cache-dir pytesseract opencv-python-headless; \
    fi
COPY . .

WORKDIR /work
USER 65532:65532

ENTRYPOINT ["python3", "/opt/condensearr/condensearr.py"]
CMD ["--help"]
