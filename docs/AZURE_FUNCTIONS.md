# Azure Functions Setup (XLink API)

This folder provides a small API with two endpoints:
- `GET /api/health` (anonymous)
- `POST /api/generate` (function key)

The API does not store data and only returns generated commands.

## Local Development

1. Install Node.js 18 and Azure Functions Core Tools.
2. Copy settings:

```bash
cd api
cp local.settings.json.example local.settings.json
```

3. Run locally:

```bash
func start
```

4. Test:

```bash
curl -i http://localhost:7071/api/health
```

## Deploy to Azure

1. Create a Function App (Linux, Consumption, Node.js 18).
2. Enable HTTPS only.
3. In the Function App settings, set CORS to `https://xasim.me`.
4. Publish from your machine:

```bash
cd api
func azure functionapp publish <your-app-name>
```

## Security Notes

- `generate` uses `authLevel: function` (requires a key).
- Do not hardcode the key in public JavaScript.
- If you want user control, let users paste their key into the UI.
- For stricter control, add IP restrictions or API Management rate limits.
- Avoid logging request bodies that may include sensitive data.

## Example Generate Request

```bash
curl -X POST "https://<your-app-name>.azurewebsites.net/api/generate?code=<FUNCTION_KEY>" \
  -H "Content-Type: application/json" \
  -d '{"hostname":"myvm","tags":["prod","bots"]}'
```
