#include "TextQuery.h"

using namespace std;
int main()
{
  ifstream infile("./text.txt");
  TextQuery tq(infile);
  while (true)
  {
    cout << "Enter word to look for, or q to quit: ";
    string s;
    if (!(cin >> s) || s == "q")
      break;
    print(cout, tq.query(s)) << endl;
  }
  return 0;
}