import sys, json
from graphify.build import build_from_json
from graphify.cluster import cluster, score_all
from graphify.analyze import god_nodes, surprising_connections, suggest_questions
from graphify.report import generate
from graphify.export import to_json
from pathlib import Path

def run_step4():
    try:
        extract_path = Path('graphify-out/.graphify_extract.json')
        detect_path = Path('graphify-out/.graphify_detect.json')
        
        if not extract_path.exists():
            print("Error: .graphify_extract.json not found.")
            return

        extraction = json.loads(extract_path.read_text())
        detection  = json.loads(detect_path.read_text())

        print(f"Building graph from {len(extraction['nodes'])} nodes and {len(extraction['edges'])} edges...")
        G = build_from_json(extraction)
        
        print("Clustering...")
        communities = cluster(G)
        
        print("Scoring cohesion...")
        cohesion = score_all(G, communities)
        
        tokens = {'input': extraction.get('input_tokens', 0), 'output': extraction.get('output_tokens', 0)}
        
        print("Analyzing...")
        gods = god_nodes(G)
        surprises = surprising_connections(G, communities)
        
        labels = {cid: f'Community {cid}' for cid in communities}
        questions = suggest_questions(G, communities, labels)

        print("Generating report...")
        report = generate(G, communities, cohesion, labels, gods, surprises, detection, tokens, '.', suggested_questions=questions)
        Path('graphify-out/GRAPH_REPORT.md').write_text(report)
        
        print("Exporting graph.json...")
        to_json(G, communities, 'graphify-out/graph.json')

        analysis = {
            'communities': {str(k): v for k, v in communities.items()},
            'cohesion': {str(k): v for k, v in cohesion.items()},
            'gods': gods,
            'surprises': surprises,
            'questions': questions,
        }
        Path('graphify-out/.graphify_analysis.json').write_text(json.dumps(analysis, indent=2))
        
        print(f"Graph: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges, {len(communities)} communities")
        print("Step 4 complete!")

    except Exception as e:
        print(f"Error in Step 4: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    run_step4()
