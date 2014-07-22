#ifndef TEXTQUERY_H
#define TEXTQUERY_H

#include <vector>
#include <set>
#include <map>
#include <memory>
// Headers for the use of other cpp files
#include <fstream>
#include <sstream>
#include <iostream>

class QueryResult;
class TextQuery {
public:
  typedef std::vector<std::string>::size_type line_no;
  TextQuery(std::ifstream&);
  QueryResult query(const std::string&) const;

private:
  std::shared_ptr<std::vector<std::string>> file; // input file
  // map of each word to the set of the lines in which that word appears
  std::map<std::string, std::shared_ptr<std::set<line_no>>> wm;
};

class QueryResult {
  friend std::ostream& print(std::ostream&, const QueryResult&);
public:
  typedef std::vector<std::string>::size_type line_no;
  QueryResult(std::string s,
              std::shared_ptr<std::set<line_no>> p,
              std::shared_ptr<std::vector<std::string>> f):
  sought(s), lines(p), file(f) {}

private:
  std::string sought; // word this query represents
  std::shared_ptr<std::set<line_no>> lines; // lines it's on
  std::shared_ptr<std::vector<std::string>> file; // input file
};

#endif