--WP Ascension
function c11110115.initial_effect(c)
	--Activate/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(11110115,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c11110115.spcond)
	e1:SetTarget(c11110115.sptg)
	e1:SetOperation(c11110115.spop)
	c:RegisterEffect(e1)
	--Destroy/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c11110115.descon)
	e2:SetOperation(c11110115.desop)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c11110115.remop)
	c:RegisterEffect(e3)
	--Checks
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c11110115.checkop)
	c:RegisterEffect(e4)
	e3:SetLabelObject(e4)
end
function c11110115.spcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11110115.spfilter(c,e,tp)
	return c:IsSetCard(0x222) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11110115.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11110115.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11110115.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11110115.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
        c:SetCardTarget(tc)
        Duel.SpecialSummonComplete()
    end
end
function c11110115.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetFirstCardTarget()
    if eg:IsContains(tc) and tc:IsReason(REASON_RELEASE) then
        e:SetLabelObject(tc)
        return true
    end
    return false
end
function c11110115.spfilter2(c,e,tp,tc)
	return c:IsSetCard(0x222) and not c:IsCode(tc:GetCode())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11110115.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetFirstCardTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c11110115.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabelObject())
    if sg:GetCount()>0 then
        if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) then   
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
        end
    end
end
function c11110115.remop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c11110115.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end