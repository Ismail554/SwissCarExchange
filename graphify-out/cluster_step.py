import json
import networkx as nx
from graphify.cluster import cluster
from pathlib import Path

def run_clustering():
    ast_path = Path('graphify-out/.graphify_ast.json')
    if not ast_path.exists():
        print("Error: .graphify_ast.json not found. Run Step 3 first.")
        return

    data = json.loads(ast_path.read_text())
    
    # Build NetworkX Graph
    G = nx.Graph()
    for node in data.get('nodes', []):
        G.add_node(node['id'], **node)
    for edge in data.get('edges', []):
        G.add_edge(edge['source'], edge['target'], **edge)
        
    print(f"Building clusters for {G.number_of_nodes()} nodes and {G.number_of_edges()} edges...")
    
    # Run clustering
    result = cluster(G)
    
    # Save to file
    # Ensure keys are strings for JSON compatibility if needed, though int keys are usually fine in dict
    # but the export tool might expect int or string. Let's keep as is for now.
    Path('graphify-out/.graphify_cluster.json').write_text(json.dumps(result, indent=2))
    print(f"Clustered: {len(result)} clusters")

if __name__ == "__main__":
    run_clustering()
