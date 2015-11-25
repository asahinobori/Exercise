#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

class Interval {
public:
    int start, end;
    Interval(int start, int end) {
        this->start = start;
        this->end = end;
        }
};

class Solution {
public:
    static bool compare(const Interval &a, const Interval &b)
    {
        return a.start < b.start;
    }
    /**
     * @param intervals: interval list.
     * @return: A new interval list.
     */
    vector<Interval> merge(vector<Interval> &intervals) {
        // write your code here
        vector<Interval> result;
        int n = intervals.size();
        if (n < 1)
        {
            return result;
        }
        sort(intervals.begin(), intervals.end(), compare);
        int left = intervals[0].start;
        int right = intervals[0].end;
        for (int i = 1; i < n; i++)
        {
            if (intervals[i].start <= right)
            {
                right = max(right, intervals[i].end);
            }
            else
            {
                result.push_back(Interval(left, right));
                left = intervals[i].start;
                right = intervals[i].end;
            }
        }

        result.push_back(Interval(left, right));

        return result;
    }
};

int main()
{
    Interval interval_1 = Interval(1, 3);
    Interval interval_2 = Interval(2, 6);
    Interval interval_3 = Interval(8, 10);
    Interval interval_4 = Interval(15, 18);
    vector<Interval> intervals;
    intervals.push_back(interval_1);
    intervals.push_back(interval_2);
    intervals.push_back(interval_3);
    intervals.push_back(interval_4);
    int nSize = intervals.size();
    Solution solution;
    vector<Interval> result = solution.merge(intervals);
    int i = 0;
    for (; i< nSize; i++)
        cout << intervals[i].start << " " << intervals[i].end << endl;
    nSize = result.size();
    i = 0;
    cout << "===result===" << endl;
    for (; i < nSize; i++)
        cout << result[i].start << " " << result[i].end << endl;
    return 0;
}


/*
 * 对所有区间的头进行排序
 * 从第1个区间开始，入栈区间头，入栈区间尾
 * 从第i个区间开始，if区间头<=栈顶,不操作，else，入栈
 * 从第i个区间开始，if区间尾<=栈顶，不操作，else if 栈元素为偶，栈顶出栈，区间尾入栈，else,入栈
 * i++,重得上面2步至所有区间被操作完
 */
 
//以上是本人的思想，核心其实和上面的代码一致，上面的代码思想如下

/*
 * 对所有区间的头进行排序
 * 从第1个区间开始，区间头标记为left，区间尾标记为right
 * 从第i个区间开始，if区间头<=right,将区间尾与right中最大的那个标记为新的right，else，left和right入队，left=i区间头，right=i区间尾
 * i++,重得上一步至所有区间被操作完
 */
