# LiveKit Server Deployment Guide - Windows

Hướng dẫn deploy LiveKit server tại `D:\livekit` trên Windows.

## Yêu cầu

- Docker Desktop đã cài đặt và đang chạy
- Ports 7880, 7881, 7882, và 50000-50100 (UDP) phải mở

## Cách 1: Dùng Docker (Khuyến nghị - Dễ nhất)

### Bước 1: Kiểm tra Docker

```powershell
docker --version
docker ps
```

Nếu `docker ps` báo lỗi API version, **restart Docker Desktop** trước.

### Bước 2: Start Server

**Option A: Dev Mode (Đơn giản nhất - Không cần config file)**

```powershell
.\start-livekit-dev.ps1
```

**Option B: Dùng docker-compose (Có config file)**

```powershell
.\start-livekit.ps1
```

Hoặc chạy thủ công:

```powershell
docker-compose up -d
```

### Bước 3: Kiểm tra Server

```powershell
.\check-livekit.ps1
```

Hoặc mở browser: http://localhost:7880

### Bước 4: Stop Server

```powershell
.\stop-livekit.ps1
```

Hoặc:

```powershell
docker-compose down
```

## Cách 2: Build từ Source (Cần Go 1.23+)

### Bước 1: Cài đặt Go

Tải và cài Go từ https://go.dev/dl/

### Bước 2: Cài đặt Mage

```powershell
go install github.com/magefile/mage@latest
```

Đảm bảo `$env:GOPATH\bin` có trong PATH.

### Bước 3: Bootstrap và Build

```powershell
cd D:\livekit
.\bootstrap.sh  # Nếu có Git Bash
# Hoặc chạy thủ công:
go mod download
mage
```

Binary sẽ ở `bin\livekit-server.exe`

### Bước 4: Chạy Server

```powershell
.\bin\livekit-server.exe --config livekit.yaml
```

Hoặc dev mode (dùng devkey:secret):

```powershell
.\bin\livekit-server.exe --dev
```

## Cấu hình

File `livekit.yaml` đã được tạo với cấu hình dev mode:
- Port: 7880
- API Key: `devkey`
- API Secret: `secret`
- URL: `ws://localhost:7880`

## Environment Variables cho App

Sau khi server chạy, set các biến sau trong app của bạn:

```powershell
$env:LIVEKIT_URL = "ws://localhost:7880"
$env:LIVEKIT_API_KEY = "devkey"
$env:LIVEKIT_API_SECRET = "secret"
```

Hoặc tạo file `.env`:

```
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

## Kiểm tra

1. **Check server đang chạy:**
   ```powershell
   .\check-livekit.ps1
   ```

2. **Test WebSocket:**
   Mở browser: http://localhost:7880

3. **Xem logs:**
   ```powershell
   docker-compose logs -f livekit
   ```

## Troubleshooting

### Docker API Version Error

Nếu bạn gặp lỗi:
```
request returned 500 Internal Server Error for API route and version
```

**Giải pháp:**
1. Restart Docker Desktop
2. Đảm bảo Docker Desktop đã update lên version mới nhất
3. Nếu vẫn lỗi, thử dùng script dev mode đơn giản: `.\start-livekit-dev.ps1`

### Port đã được sử dụng

Nếu port 7880 đã được dùng, sửa `livekit.yaml`:

```yaml
port: 7881  # Đổi port khác
```

Và cập nhật `docker-compose.yml` mapping port tương ứng.

### Docker không chạy

Đảm bảo Docker Desktop đang chạy và không bị lỗi.

### Firewall chặn UDP ports

Mở Windows Firewall cho ports:
- 7880 (TCP)
- 7881 (TCP)  
- 7882 (UDP)
- 50000-50100 (UDP)

### Server không respond

1. Check logs: `docker-compose logs livekit`
2. Check container: `docker-compose ps`
3. Restart: `docker-compose restart`

## Production Notes

⚠️ **Dev mode (`devkey:secret`) chỉ dùng cho development!**

Cho production:
1. Generate key/secret mới:
   ```powershell
   docker run --rm livekit/livekit-server:latest livekit-server generate-keys
   ```

2. Cập nhật `livekit.yaml` với key/secret mới

3. Cấu hình TLS và domain thật

4. Setup TURN server nếu cần

5. Cấu hình Redis nếu muốn distributed mode

## Scripts có sẵn

- `start-livekit.ps1` - Start server
- `stop-livekit.ps1` - Stop server  
- `check-livekit.ps1` - Check status và health

## Tham khảo

- [LiveKit Docs](https://docs.livekit.io)
- [Deployment Guide](https://docs.livekit.io/deploy/)
- [Config Reference](https://docs.livekit.io/self-hosting/config/)

