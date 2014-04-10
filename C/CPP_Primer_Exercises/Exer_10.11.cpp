#include <string>
#include <iostream>
#include <vector>
#include <algorithm>

using std::string;
using std::cout;
using std::endl;
using std::vector;

bool isShorter(const string &s1, const string &s2) {
  return s1.size() < s2.size();
}

void elimDups(vector<string> &words) {
  sort(words.begin(), words.end());
  auto end_unique = unique(words.begin(), words.end());
  words.erase(end_unique, words.end());
}

int main() {
  vector<string> story = {"the", "quick", "red", "fox",
                          "jumps", "over", "the", "slow",
                          "red", "turtle"};

  elimDups(story);
  stable_sort(story.begin(), story.end(), isShorter);
  for (const auto &s : story)
    cout << s << " ";
  cout << endl;

  return 0;
}
