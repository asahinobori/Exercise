/*
 * 目的：一个简单的文本查询程序
 * 作用：程序将读取用户指定的任意文本文件，然后允许用户从该文件中查找单词。
 * 查询的结果是该单词出现的次数，并列出每次出现所在的行。
 * 如果某单词在同一行中多次出现，程序将只显示该行一次。
 * 行号按升序显示，即第 7 行应该在第 9 行之前输出，依此类推。
 */

/* 思路：
 * 1.使用一个 vector<string> 类型的对象存储整个输入文件的副本。
 *   输入文件的每一行是该 vector 对象的一个元素。
 *   因而，在希望输出某一行时，只需以行号为下标获取该行所在的元素即可。
 * 2.将每个单词所在的行号存储在一个 set 容器对象中。
 *   使用 set 就可确保每行只有一个条目，而且行号将自动按升序排列。
 * 3.使用一个 map 容器将每个单词与一个 set 容器对象关联起来，
 *   该 set 容器对象记录此单词所在的行号。
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