#include "Query.h"
#include "TextQuery.h"

#include <string>
using std::string;

#include <iostream>
using std::cin; using std::cout; using std::endl;

int main(int argc, char **argv)
{
  // gets file to read and builds map to support queries
  TextQuery file = get_file(argc, argv);

  // iterate with the user: prompt for a word to find and print results
  while (true) {
    string sought1, sought2, sought3;
    if (!get_words(sought1, sought2)) break;
    cout << "\nenter third word: ";
    cin >> sought3;
    // find all the occurrences of the requested string
    Query q = Query(sought1) & Query(sought2) | Query(sought3);
    cout << "\nExecuting Query for: " << q << endl;
    const auto results = q.eval(file);
    // report matches
    print(cout, results);
  }
  return 0;
}