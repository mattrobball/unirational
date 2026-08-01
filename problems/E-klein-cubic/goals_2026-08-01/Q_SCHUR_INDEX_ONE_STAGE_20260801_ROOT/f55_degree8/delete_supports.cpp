#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <unordered_set>
#include <vector>
using namespace std;

struct Mask { uint64_t lo,hi; bool operator==(Mask const&o)const{return lo==o.lo&&hi==o.hi;} };
struct Hash { size_t operator()(Mask const&m)const{return m.lo^(m.hi+0x9e3779b97f4a7c15ULL+(m.lo<<6)+(m.lo>>2));} };
struct Occ { int equation; Mask term; };
vector<vector<Mask>> eqs;
vector<vector<Occ>> occurrences;
vector<int> active_count;
unordered_set<Mask,Hash> seen;
uint64_t nodes=0;
int nvar;
bool reverse_order=false;

inline bool subset(Mask a,Mask s){return(a.lo&s.lo)==a.lo&&(a.hi&s.hi)==a.hi;}
inline int pc(Mask a){return __builtin_popcountll(a.lo)+__builtin_popcountll(a.hi);}
inline bool bit(Mask a,int i){return i<64?(a.lo>>i&1):(a.hi>>(i-64)&1);}

Mask singleton(Mask support,bool&has){
  has=false;Mask best{0,0};int best_size=4;
  for(int z=0;z<(int)eqs.size();z++){
    int e=reverse_order?(int)eqs.size()-1-z:z;
    if(active_count[e]!=1)continue;
    Mask one{0,0};
    if(reverse_order){for(auto it=eqs[e].rbegin();it!=eqs[e].rend();++it)if(subset(*it,support)){one=*it;break;}}
    else for(Mask t:eqs[e])if(subset(t,support)){one=t;break;}
    int k=pc(one);if(k<best_size){best=one;best_size=k;has=true;if(k==1)return best;}
  }
  return best;
}

bool dfs(Mask support){
  if(!seen.insert(support).second)return false;
  nodes++;
  bool has;Mask witness=singleton(support,has);
  if(!has){
    if(support.lo||support.hi){
      cout<<"FOUND_STOPPING_SUPPORT size="<<pc(support)<<"\n";
      return true;
    }
    return false;
  }
  vector<int> variables;
  for(int i=0;i<nvar;i++)if(bit(witness,i))variables.push_back(i);
  sort(variables.begin(),variables.end(),[](int a,int b){
    return reverse_order?occurrences[a].size()<occurrences[b].size():occurrences[a].size()>occurrences[b].size();
  });
  for(int variable:variables){
    vector<int> changed;changed.reserve(occurrences[variable].size());
    for(auto const&o:occurrences[variable])if(subset(o.term,support)){
      active_count[o.equation]--;changed.push_back(o.equation);
    }
    Mask child=support;
    if(variable<64)child.lo&=~(1ULL<<variable);else child.hi&=~(1ULL<<(variable-64));
    bool found=dfs(child);
    for(int e:changed)active_count[e]++;
    if(found)return true;
  }
  return false;
}

int main(int argc,char**argv){
  if(argc<2||argc>3)return 2;
  if(argc==3)reverse_order=string(argv[2])=="reverse";
  ifstream f(argv[1],ios::binary);uint32_t n,e;f.read((char*)&n,4);f.read((char*)&e,4);
  nvar=n;eqs.resize(e);occurrences.resize(n);active_count.resize(e);size_t total=0;
  for(int j=0;j<(int)e;j++){
    uint32_t k;f.read((char*)&k,4);eqs[j].resize(k);active_count[j]=k;total+=k;
    for(Mask &m:eqs[j]){
      f.read((char*)&m.lo,8);f.read((char*)&m.hi,8);
      for(int i=0;i<nvar;i++)if(bit(m,i))occurrences[i].push_back({j,m});
    }
  }
  Mask full{n>=64?~0ULL:((1ULL<<n)-1),n<=64?0:((1ULL<<(n-64))-1)};
  cout<<"INSTANCE variables="<<n<<" equations="<<e<<" terms="<<total<<" order="<<(reverse_order?"reverse":"forward")<<"\n";
  bool found=dfs(full);
  cout<<"RESULT "<<(found?"FOUND_STOPPING_SUPPORT":"NO_STOPPING_SUPPORT")<<" states="<<nodes<<"\n";
  return found?1:0;
}
