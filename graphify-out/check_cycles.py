import json
import networkx as nx

def find_cycles():
    with open('graphify-out/graph.json') as f:
        data = json.load(f)
    
    G = nx.DiGraph()
    for edge in data['edges']:
        G.add_edge(edge['source'], edge['target'])
    
    try:
        cycles = list(nx.simple_cycles(G))
        print(f"Found {len(cycles)} cycles.")
        for cycle in cycles[:10]:
            print(" -> ".join(cycle))
    except Exception as e:
        print(f"Error finding cycles: {e}")

if __name__ == "__main__":
    find_cycles()
