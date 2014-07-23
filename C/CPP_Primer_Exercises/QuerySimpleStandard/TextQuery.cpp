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