# 🚀 LiveKit Quick Start - Windows

## Bước nhanh để chạy LiveKit server

### 1. Đảm bảo Docker Desktop đang chạy

Mở Docker Desktop và đợi nó khởi động hoàn toàn.

### 2. Start Server (Chọn 1 trong 2 cách)

**Cách A: Dev Mode (Khuyến nghị - Đơn giản nhất)**

```powershell
cd D:\livekit
.\start-livekit-dev.ps1
```

**Cách B: Dùng docker-compose**

```powershell
cd D:\livekit
.\start-livekit.ps1
```

### 3. Kiểm tra Server

Mở browser: **http://localhost:7880**

Hoặc chạy:
```powershell
.\check-livekit.ps1
```

### 4. Thông tin kết nối

Sau khi server chạy, dùng các thông tin sau trong app của bạn:

```
LIVEKIT_URL=ws://localhost:7880
LIVEKIT_API_KEY=devkey
LIVEKIT_API_SECRET=secret
```

> 💡 **API Key/Secret được config ở đâu?**
> - **Trong server:** File `livekit.yaml` (dòng 19-20)
> - **Trong app:** Set environment variables như trên
> - Xem chi tiết: `SETUP-API-KEYS.md`

### 5. Stop Server

```powershell
.\stop-livekit-dev.ps1
# hoặc
.\stop-livekit.ps1
```

---

## ⚠️ Nếu gặp lỗi

### Lỗi Docker API Version
```
request returned 500 Internal Server Error for API route
```

**Giải pháp:** Restart Docker Desktop

### Port đã được sử dụng
Sửa port trong `livekit.yaml` hoặc stop service đang dùng port 7880.

### Xem logs
```powershell
docker logs -f livekit-server-dev
# hoặc
docker-compose logs -f livekit
```

---

## 📚 Tài liệu đầy đủ

Xem `README-DEPLOY.md` để biết thêm chi tiết về:
- Build từ source
- Cấu hình production
- Troubleshooting chi tiết

