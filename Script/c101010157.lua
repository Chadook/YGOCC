--created & coded by Lyris
--S・VINEの女王クライッシャ
function c101010157.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101010157)
	e1:SetCondition(c101010157.spcon)
	e1:SetOperation(c101010157.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101010157)
	e2:SetTarget(c101010157.rmtg)
	e2:SetOperation(c101010157.rmop)
	c:RegisterEffect(e2)
end
function c101010157.cfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=8 and not c:IsImmuneToEffect(e)
end
function c101010157.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.IsExistingMatchingCard(c101010157.cfilter,tp,0,LOCATION_MZONE,2,nil,e)
end
function c101010157.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c101010157.cfilter,tp,0,LOCATION_MZONE,2,2,nil,e)
	Duel.Hint(HINT_CARD,0,101010157)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(8)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101010157.filter(c)
	local code=c:GetCode()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and code~=101010157 and c:IsAbleToHand()
end
function c101010157.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c101010157.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010157.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(c101010157.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
