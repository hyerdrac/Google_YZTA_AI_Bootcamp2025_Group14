import gradio as gr
import pickle
import pandas as pd

MODEL_PATH = "lung_cancer.pkl"  # Yeni model dosyanın adı

# Modeli yükle
try:
    with open(MODEL_PATH, 'rb') as f:
        model = pickle.load(f)
    print("Model başarıyla yüklendi.")
except FileNotFoundError:
    print(f"Hata: {MODEL_PATH} bulunamadı. Lütfen model dosyasını Space'inize yüklediğinizden emin olun.")
    model = None
except Exception as e:
    print(f"Model yüklenirken bir hata oluştu: {e}")
    model = None

def encode_gender(gender: str) -> int:
    """Gender stringini sayısala dönüştürür."""
    gender = gender.strip().upper()
    if gender == 'M':
        return 1
    elif gender == 'F':
        return 0
    else:
        return -1  # Hatalı giriş

def predict_new_model(
    Gender: str,
    Age: float,
    Smoking: int,
    Yellow_fingers: int,
    Anxiety: int,
    Peer_pressure: int,
    Chronic_Disease: int,
    Fatigue: int,
    Allergy: int,
    Wheezing: int,
    Alcohol: int,
    Coughing: int,
    Shortness_of_Breath: int,
    Swallowing_Difficulty: int,
    Chest_pain: int
) -> str:
    if model is None:
        return "Model yüklenemedi. Lütfen Space loglarını kontrol edin."
    
    gender_encoded = encode_gender(Gender)
    if gender_encoded == -1:
        return "Gender alanı yalnızca 'M' veya 'F' olabilir."
    
    feature_names = [
        'Gender',
        'Age',
        'Smoking',
        'Yellow fingers',
        'Anxiety',
        'Peer_pressure',
        'Chronic Disease',
        'Fatigue',
        'Allergy',
        'Wheezing',
        'Alcohol',
        'Coughing',
        'Shortness of Breath',
        'Swallowing Difficulty',
        'Chest pain'
    ]
    
    input_data = [
        gender_encoded,
        Age,
        Smoking,
        Yellow_fingers,
        Anxiety,
        Peer_pressure,
        Chronic_Disease,
        Fatigue,
        Allergy,
        Wheezing,
        Alcohol,
        Coughing,
        Shortness_of_Breath,
        Swallowing_Difficulty,
        Chest_pain
    ]
    
    features_df = pd.DataFrame([input_data], columns=feature_names)
    
    try:
        prediction = model.predict(features_df)[0]
        prediction_proba = model.predict_proba(features_df)[0]
        
        if prediction == 1:
            return f"Tahmin: Hastalık Var (Olasılık: %{prediction_proba[1]*100:.2f})"
        else:
            return f"Tahmin: Hastalık Yok (Olasılık: %{prediction_proba[0]*100:.2f})"
    except Exception as e:
        return f"Tahmin sırasında hata oluştu: {e}"

iface = gr.Interface(
    fn=predict_new_model,
    inputs=[
        gr.Radio(choices=['M', 'F'], label="Cinsiyet (Gender)"),
        gr.Number(label="Yaş (Age)", precision=0),
        gr.Radio(choices=[1,2], label="Sigara (Smoking): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Sarı Parmaklar (Yellow fingers): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Anksiyete (Anxiety): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Baskı (Peer_pressure): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Kronik Hastalık (Chronic Disease): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Yorgunluk (Fatigue): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Alerji (Allergy): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Hırıltı (Wheezing): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Alkol (Alcohol): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Öksürük (Coughing): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Nefes Darlığı (Shortness of Breath): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Yutma Güçlüğü (Swallowing Difficulty): 1=Hayır, 2=Evet"),
        gr.Radio(choices=[1,2], label="Göğüs Ağrısı (Chest pain): 1=Hayır, 2=Evet")
    ],
    outputs="text",
    title="Yeni Model Tahmin Uygulaması",
    description="Lütfen belirtilen alanları doldurun ve tahmin yapın."
)

if __name__ == "__main__":
    iface.launch()