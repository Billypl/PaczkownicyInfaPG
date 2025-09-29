
#include <wchar.h>
#include <windows.h>

int main() {
    HANDLE out, in;
    DWORD nwr, nrd;
    wchar_t text[] = L"<ą|ę|ł|Б|\u0413>";
    wchar_t txt[128];
    in = GetStdHandle(STD_INPUT_HANDLE);
    out = GetStdHandle(STD_OUTPUT_HANDLE);
    ReadConsoleW(in, txt, sizeof(txt) / sizeof(txt[0]), &nrd, NULL);
    txt[nrd] = 0;
    WriteConsoleW(out, text, wcslen(text), &nwr, NULL);
    WriteConsoleW(out, L"\n", 1, &nwr, NULL);
    WriteConsoleW(out, txt, nrd, &nwr, NULL);
    return 0;
};
