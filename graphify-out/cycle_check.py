import json
import networkx as nx
from pathlib import Path

def check_cycles():
    try:
        extract_path = Path('graphify-out/.graphify_extract.json')
        if not extract_path.exists():
            print("Error: .graphify_extract.json not found.")
            return

        extraction = json.loads(extract_path.read_text())
        G = nx.DiGraph()
        for node in extraction['nodes']:
            G.add_node(node['id'])
        for edge in extraction['edges']:
            G.add_edge(edge['source'], edge['target'])

        cycles = list(nx.simple_cycles(G))
        if cycles:
            print(f"Found {len(cycles)} dependency cycles!")
            # Filter for small cycles (usually more interesting)
            small_cycles = [c for c in cycles if len(c) <= 5]
            print(f"Small cycles (up to 5 nodes): {len(small_cycles)}")
            for i, cycle in enumerate(small_cycles[:10]):
                print(f"Cycle {i+1}: {' -> '.join(cycle)}")
            
            Path('graphify-out/.graphify_cycles.json').write_text(json.dumps(cycles, indent=2))
        else:
            print("No dependency cycles found.")
            Path('graphify-out/.graphify_cycles.json').write_text("[]")

    except Exception as e:
        print(f"Error checking cycles: {e}")

if __name__ == '__main__':
    check_cycles()
