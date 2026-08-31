#!/bin/bash

echo "=========================================="
echo "   BẮT ĐẦU DỌN DẸP HỆ THỐNG ARCH LINUX"
echo "=========================================="

# Nhập mật khẩu sudo trước
sudo -v

echo -e "\n[1/6] --> Đang gỡ bỏ các gói mồ côi (Orphans)..."
if [ -n "$(pacman -Qtdq)" ]; then
    # Bỏ bớt --noconfirm nếu bạn muốn xem danh sách trước khi nhấn gỡ
    sudo pacman -Rns $(pacman -Qtdq)
else
    echo "Không có gói mồ côi nào để xóa."
fi

echo -e "\n[2/6] --> Đang dọn dẹp bộ nhớ đệm của Pacman..."
# Xóa lệnh --noconfirm cũ để Pacman hiện rõ dung lượng và hỏi bạn có muốn xóa không
sudo pacman -Scc

echo -e "\n[3/6] --> Đang dọn dẹp bộ nhớ đệm của YAY (AUR)..."
if command -v yay &> /dev/null; then
    yay -Scc
fi

echo -e "\n[4/6] --> Đang dọn dẹp Nhật ký hệ thống (Journal Logs)..."
sudo journalctl --vacuum-size=50M

echo -e "\n[5/6] --> Đang xóa Thùng rác (Trash)..."
# Thêm chữ -v (verbose) để hiện danh sách file bị xóa
rm -rfv ~/.local/share/Trash/*

echo -e "\n[6/6] --> Đang dọn dẹp bộ nhớ đệm cá nhân (~/.cache)..."
# Thêm chữ -v (verbose) để màn hình chạy liên tục các file cache đang bị xóa
rm -rfv ~/.cache/*

echo "=========================================="
echo "   ĐÃ DỌN DẸP XONG! HỆ THỐNG SẠCH SẼ!"
echo "=========================================="