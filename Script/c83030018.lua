--Carefree Family
function c83030018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,83030018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c83030018.condition)
	e1:SetTarget(c83030018.target)
	e1:SetOperation(c83030018.activate)
	c:RegisterEffect(e1)
end
function c83030018.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x833)
end
function c83030018.condition(e,tp,eg,ep,ev,re,r,rp)
	local pct=Duel.GetMatchingGroupCount(c83030018.cfilter,tp,LOCATION_MZONE,0,nil)
	local oct=Duel.GetMatchingGroupCount(c83030018.cfilter,tp,0,LOCATION_MZONE,nil)
	return pct>oct and oct>0
end
function c83030018.filter(c,tp)
	return c:IsControlerCanBeChanged() and c:IsFaceup() and c:IsSetCard(0x833) and c:GetOwner()==tp
end
function c83030018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c83030018.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c83030018.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c83030018.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c83030018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
