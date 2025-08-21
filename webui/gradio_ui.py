import gradio as gr
from ollama import Client

client = Client(host='http://localhost:11434')

def chat_with_model(model, message, history):
    try:
        response = client.generate(model=model, prompt=message)
        return response['response']
    except Exception as e:
        return f"Błąd: {str(e)}"

iface = gr.ChatInterface(
    fn=chat_with_model,
    additional_inputs=[
        gr.Textbox(label="Model", value="llama3", interactive=True)
    ],
    title="ArekBox AI Chat (Ollama + Gradio)"
)

iface.launch(share=False)
