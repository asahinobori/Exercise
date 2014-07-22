/*
 * Ŀ�ģ�һ���򵥵��ı���ѯ����
 * ���ã����򽫶�ȡ�û�ָ���������ı��ļ���Ȼ�������û��Ӹ��ļ��в��ҵ��ʡ�
 * ��ѯ�Ľ���Ǹõ��ʳ��ֵĴ��������г�ÿ�γ������ڵ��С�
 * ���ĳ������ͬһ���ж�γ��֣�����ֻ��ʾ����һ�Ρ�
 * �кŰ�������ʾ������ 7 ��Ӧ���ڵ� 9 ��֮ǰ������������ơ�
 */

/* ˼·��
 * 1.ʹ��һ�� vector<string> ���͵Ķ���洢���������ļ��ĸ�����
 *   �����ļ���ÿһ���Ǹ� vector �����һ��Ԫ�ء�
 *   �������ϣ�����ĳһ��ʱ��ֻ�����к�Ϊ�±��ȡ�������ڵ�Ԫ�ؼ��ɡ�
 * 2.��ÿ���������ڵ��кŴ洢��һ�� set ���������С�
 *   ʹ�� set �Ϳ�ȷ��ÿ��ֻ��һ����Ŀ�������кŽ��Զ����������С�
 * 3.ʹ��һ�� map ������ÿ��������һ�� set �����������������
 *   �� set ���������¼�˵������ڵ��кš�
 */

#include "TextQuery.h"

using namespace std;

inline string make_plural(size_t ctr, const string &word, const string &ending)
{
  return (ctr > 1) ? word + ending : word;
}

TextQuery::TextQuery(ifstream &is) : file(new vector<string>)
{
  string text;
  while (getline(is, text)) {
    file->push_back(text);
    int n = file->size() - 1;
    istringstream line(text);
    string word;
    while (line >> word) {
      auto &lines = wm[word];
      if (!lines)
        lines.reset(new set<line_no>);
      lines->insert(n);
    }
  }
}

QueryResult TextQuery::query(const string &sought) const
{
  static shared_ptr<set<line_no>> nodata(new set<line_no>);
  auto loc = wm.find(sought);
  if (loc == wm.end())
    return QueryResult(sought, nodata, file); //not found
  else
    return QueryResult(sought, loc->second, file);
}

ostream &print(ostream &os, const QueryResult &qr)
{
  os << qr.sought << " occurs " << qr.lines->size() << " "
     << make_plural(qr.lines->size(), "time", "s") << endl;
  for (auto num : *qr.lines)
    os << "\t(line " << num + 1 << ") "
       << *(qr.file->begin() + num) << endl;
  return os;
}