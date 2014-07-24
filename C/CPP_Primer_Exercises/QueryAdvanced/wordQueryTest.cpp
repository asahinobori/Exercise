#include "Query.h"
#include "TextQuery.h"

#include <string>
#include <iostream>

using std::string;
using std::cout;
using std::endl;


int main(int argc, char **argv)
{
  TextQuery file = get_file(argc, argv);

  // iterate with the user: prompt for a word to find and print results
  do {
    string sought;
    if (!get_word(sought)) break;

    // find all the occurrences of the requested string
    // define synonym for the line_no set
    Query name(sought);
    const auto results = name.eval(file);
    cout << "\nExecuting Query for: " << name << endl;

    // report no matches
    print(cout, results) << endl;
  } while (true); // loop indefinitely; the exit is inside the loop
  return 0;
}