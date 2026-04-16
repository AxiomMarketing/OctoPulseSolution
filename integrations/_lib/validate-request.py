#!/usr/bin/env python3
"""Validate an API request payload against a JSON Schema."""
import json, sys, os

def main():
    if len(sys.argv) < 3:
        print("Usage: validate-request.py <schema_file> <payload_file>", file=sys.stderr)
        sys.exit(2)

    schema_file = sys.argv[1]
    payload_file = sys.argv[2]

    if not os.path.isfile(schema_file):
        print(json.dumps({"valid": True, "warning": "no_schema", "schema": schema_file}))
        return

    try:
        from jsonschema import validate, ValidationError, SchemaError
    except ImportError:
        print(json.dumps({"valid": True, "warning": "jsonschema_not_installed"}))
        return

    schema = json.load(open(schema_file))

    if payload_file == "-":
        payload = json.load(sys.stdin)
    else:
        payload = json.load(open(payload_file))

    try:
        validate(instance=payload, schema=schema)
        print(json.dumps({"valid": True}))
    except ValidationError as e:
        path = " > ".join(str(p) for p in e.absolute_path) if e.absolute_path else "root"
        result = {
            "valid": False,
            "error": e.message[:500],
            "path": path,
            "hint": f"Fix '{path}' in your payload. Schema: {schema_file}"
        }
        print(json.dumps(result))
        sys.exit(1)
    except SchemaError as e:
        print(json.dumps({"valid": False, "error": f"Schema error: {e.message[:200]}"}))
        sys.exit(1)

if __name__ == "__main__":
    main()
