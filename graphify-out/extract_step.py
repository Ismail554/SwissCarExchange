import sys, json, os, time, traceback
from pathlib import Path
from graphify.extract import collect_files, extract
from graphify.llm import extract_corpus_parallel, detect_backend

# Set the API Key (Read from environment for security)
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY", "YOUR_API_KEY_HERE")

def run_extraction():
    detect_path = Path('graphify-out/.graphify_detect.json')
    if not detect_path.exists():
        print("Error: .graphify_detect.json not found. Run Step 2 first.")
        return

    detect = json.loads(detect_path.read_text())
    code_roots = detect.get('files', {}).get('code', [])
    doc_roots = detect.get('files', {}).get('docs', [])
    
    code_files = []
    for r in code_roots:
        p = Path(r)
        code_files.extend(collect_files(p) if p.is_dir() else [p])
    
    doc_files = []
    for r in doc_roots:
        p = Path(r)
        doc_files.extend(collect_files(p) if p.is_dir() else [p])

    # Part A: Structural (AST)
    print(f"Running AST extraction on {len(code_files)} files...")
    ast_result = extract(code_files, cache_root=Path('.')) if code_files else {"nodes":[], "edges":[], "hyperedges":[], "input_tokens":0, "output_tokens":0}
    Path('graphify-out/.graphify_ast.json').write_text(json.dumps(ast_result, indent=2))
    print(f"AST: {len(ast_result['nodes'])} nodes, {len(ast_result['edges'])} edges")

    # Part B: Semantic (LLM)
    all_files = list(set(code_files + doc_files))
    backend = detect_backend()
    semantic_result = {"nodes":[], "edges":[], "hyperedges":[], "input_tokens":0, "output_tokens":0}
    
    if backend and all_files:
        print(f"Running semantic extraction using {backend} on {len(all_files)} files...")
        def on_chunk(idx, total, res):
            print(f"  Chunk {idx+1}/{total} done: {len(res.get('nodes', []))} nodes, {len(res.get('edges', []))} edges")
            
        try:
            semantic_result = extract_corpus_parallel(
                all_files, 
                backend=backend, 
                chunk_size=10, 
                on_chunk_done=on_chunk
            )
            Path('graphify-out/.graphify_semantic.json').write_text(json.dumps(semantic_result, indent=2))
            print(f"Semantic: {len(semantic_result['nodes'])} nodes, {len(semantic_result['edges'])} edges")
        except Exception as e:
            print(f"Warning: Semantic extraction failed: {e}")
            traceback.print_exc()
            print("Proceeding with AST-only results.")
    else:
        print("No backend or no files - skipping semantic extraction")

    # Part C: Merge
    merged = {
        "nodes": ast_result.get("nodes", []) + semantic_result.get("nodes", []),
        "edges": ast_result.get("edges", []) + semantic_result.get("edges", []),
        "hyperedges": ast_result.get("hyperedges", []) + semantic_result.get("hyperedges", []),
        "input_tokens": ast_result.get("input_tokens", 0) + semantic_result.get("input_tokens", 0),
        "output_tokens": ast_result.get("output_tokens", 0) + semantic_result.get("output_tokens", 0)
    }
    
    # Final output
    Path('graphify-out/.graphify_ast.json').write_text(json.dumps(merged, indent=2))
    print(f"Extraction complete! Total nodes: {len(merged['nodes'])}, Total edges: {len(merged['edges'])}")

if __name__ == "__main__":
    run_extraction()
