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
#include "make_plural.h"

#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <set>
#include <memory>
#include <iostream>


using std::string;
using std::vector;
using std::set;
using std::ifstream;
using std::istringstream;
using std::shared_ptr;
using std::ostream;
using std::endl;
using std::cout;

// read the input file and build the map of lines to line numbers
TextQuery::TextQuery(ifstream &is) : file(new vector<string>)
{
  string text;
  while (getline(is, text)) {   // for each line in the file
    file->push_back(text);      // remember this line of text
    int n = file->size() - 1;   // the current line number
    istringstream line(text);   // separate the line into words
    string word;
    while (line >> word) {      // for each word in that line
      word = cleanup_str(word);
      // if word isn't already in wm, subscripting adds a new entry
      auto &lines = wm[word];   // lines is a shared_ptr
      if (!lines)               // that pointer is null the first time we see word
        lines.reset(new set<line_no>); // allocate a new set
      lines->insert(n);         // insert this line number
    }
  }
}

// not covered in the book -- cleanup_str removes
// punctuation and converts all text to lowercase so that
// the queries operate in a case insensitive manner
string TextQuery::cleanup_str(const string &word)
{
  string ret;
  for (auto it = word.begin(); it != word.end(); ++it) {
    if (!ispunct(*it))
      ret += tolower(*it);
  }
  return ret;
}

QueryResult TextQuery::query(const string &sought) const
{
  // we'll return a pointer to this set if we don't find sought
  static shared_ptr<set<line_no>> nodata(new set<line_no>);
  auto loc = wm.find(sought);
  if (loc == wm.end())
    return QueryResult(sought, nodata, file); //not found
  else
    return QueryResult(sought, loc->second, file);
}

ostream &print(ostream &os, const QueryResult &qr)
{
  // if the word was found, print the count and all occurrences
  os << qr.sought << " occurs " << qr.lines->size() << " "
     << make_plural(qr.lines->size(), "time", "s") << endl;
  // print each line in which the word appeared
  for (auto num : *qr.lines)
    os << "\t(line " << num + 1 << ") "
       << *(qr.file->begin() + num) << endl;
  return os;
}

// debugging routine, not covered in the book
void TextQuery::display_map()
{
  auto iter = wm.cbegin(), iter_end = wm.cend();

  // for each word in the map
  for ( ; iter != iter_end; ++iter) {
    cout << "word: " << iter->first << " {";

    // fetch location vector as a const reference to avoid copying it
    auto text_locs = iter->second;
    auto loc_iter = text_locs->cbegin(), loc_iter_end = text_locs->cend();

    // print all line numbers for this word
    while (loc_iter != loc_iter_end)
    {
      cout << *loc_iter;
      if (++loc_iter != loc_iter_end)
        cout << ", ";
    }

    cout << "}\n"; // end list of output this word
  }
  cout << endl;
}