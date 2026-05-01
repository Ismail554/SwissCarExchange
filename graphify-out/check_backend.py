import json
from graphify.llm import detect_backend
from pathlib import Path

try:
    backend = detect_backend()
    print(f"Detected default backend: {backend}")
except Exception as e:
    print(f"Error detecting backend: {e}")
