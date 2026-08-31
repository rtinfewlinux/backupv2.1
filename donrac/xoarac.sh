#!/bin/bash

echo "=========================================="
echo "   BẮT ĐẦU DỌN DẸP TỰ ĐỘNG ARCH LINUX"
echo "=========================================="

# Nhập mật khẩu một lần duy nhất ở đây
sudo -v

echo -e "\n[1/5] --> Đang tự động gỡ các gói mồ côi (Orphans)..."
if [ -n "$(pacman -Qtdq)" ]; then
    sudo pacman -Rns $(pacman -Qtdq) --noconfirm
else
    echo "Không có gói mồ côi nào."
fi

echo -e "\n[2/5] --> Đang tự động dọn bộ nhớ đệm Pacman..."
# Nhấn Y 2 lần tự động bằng lệnh echo
echo -e "y\ny" | sudo pacman -Scc

echo -e "\n[3/5] --> Đang tự động dọn bộ nhớ đệm YAY (AUR)..."
if command -v yay &> /dev/null; then
    echo -e "y\ny" | yay -Scc
fi

echo -e "\n[4/5] --> Đang dọn dẹp Nhật ký hệ thống (Journal Logs)..."
sudo journalctl --vacuum-size=50M

echo -e "\n[5/5] --> Đang quét sạch Thùng rác và Cache ẩn (Hiện chi tiết)..."
# Giữ -v để chữ chạy liên tục lên màn hình, xóa cực sạch không hỏi câu nào
rm -rfv ~/.local/share/Trash/*
rm -rfv ~/.cache/*

echo "=========================================="
echo "   ĐÃ DỌN XONG 100%! KHÔNG CÒN RÁC THỪA!"
echo "=========================================="