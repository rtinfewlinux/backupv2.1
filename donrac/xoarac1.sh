#!/bin/bash

echo "=========================================="
echo "   BẮT ĐẦU DỌN DẸP TỰ ĐỘNG ARCH LINUX"
echo "=========================================="

# Nhập mật khẩu một lần duy nhất ở đây
sudo -v

echo -e "\n[1/6] --> Đang tự động gỡ các gói mồ côi (Orphans)..."
while [ -n "$(pacman -Qtdq)" ]; do
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm
done

echo -e "\n[2/6] --> Đang tự động dọn bộ nhớ đệm Pacman..."
sudo pacman -Sc --noconfirm

echo -e "\n[3/6] --> Đang tự động dọn bộ nhớ đệm và mã nguồn YAY (AUR)..."
if command -v yay &> /dev/null; then
    yay -Scc --noconfirm
    rm -rfv ~/.cache/yay/*
fi

echo -e "\n[4/6] --> Đang dọn dẹp Nhật ký hệ thống (Journal Logs)..."
sudo journalctl --vacuum-size=50M

echo -e "\n[5/6] --> Đang xóa sạch Core Dumps (File lỗi hệ thống)..."
sudo rm -rfv /var/lib/systemd/coredump/*

echo -e "\n[6/6] --> Đang quét sạch Thùng rác và Cache ẩn..."
find ~/.config ~/.local -xtype l -delete 2>/dev/null
rm -rfv ~/.local/share/Trash/*
find ~/.cache -mindepth 1 -maxdepth 1 -not -name 'yay' -exec rm -rfv {} + 2>/dev/null

echo "=========================================="
echo "   ĐÃ DỌN XONG 100%! HỆ THỐNG SẠCH BONG!"
echo "=========================================="
