#!/bin/bash

echo "=========================================="
echo "   BẮT ĐẦU DỌN DẸP HỆ THỐNG ARCH LINUX"
echo "=========================================="

# 1. Cần quyền sudo để dọn dẹp hệ thống trước
sudo -v

echo "--> Đang gỡ bỏ các gói mồ côi (Orphans)..."
if [ -n "$(pacman -Qtdq)" ]; then
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm
else
    echo "Không có gói mồ côi nào."
fi

echo "--> Đang dọn dẹp bộ nhớ đệm của Pacman..."
sudo pacman -Scc --noconfirm

echo "--> Đang dọn dẹp bộ nhớ đệm của YAY (AUR)..."
if command -v yay &> /dev/null; then
    yay -Scc --noconfirm
fi

echo "--> Đang dọn dẹp Thùng rác (Trash)..."
rm -rf ~/.local/share/Trash/*

echo "--> Đang dọn dẹp bộ nhớ đệm cá nhân (~/.cache)..."
# Giữ lại các thư mục cấu hình quan trọng trong cache nếu cần, xóa các file rác còn lại
rm -rf ~/.cache/*

echo "=========================================="
echo "   ĐÃ DỌN DẸP XONG! HỆ THỐNG SẠCH SẼ!"
echo "=========================================="
