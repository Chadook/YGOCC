--Payout of Eternity
function c19454008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c19454008.activate)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c19454008.target)
	e2:SetOperation(c19454008.operation)
	c:RegisterEffect(e2)
end
function c19454008.cfilter(c)
	return c:IsSetCard(0xe6b) and c:IsType(TYPE_MONSTER)
end
function c19454008.activate(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	if not e:GetHandler():IsRelateToEffect(e) or lp2-lp1<4000 then return end
	local g=Duel.GetMatchingGroup(c19454008.cfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(19454008,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,2,2,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,sg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
			if Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnCount()>=2 then
				e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
			else
				if Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetTurnCount()==1 then
					e1:SetCode(EVENT_PHASE_START+PHASE_END)
				end
			end
			e1:SetCountLimit(1)
			e1:SetCondition(c19454008.discon)
			e1:SetOperation(c19454008.disop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c19454008.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c19454008.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) then
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,2,2,nil)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	else Duel.Destroy(c,REASON_RULE) end
end
function c19454008.filter(c,e)
	return c:IsSetCard(0xe6b) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function c19454008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and c19454008.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c19454008.filter,tp,LOCATION_MZONE,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c19454008.filter,tp,LOCATION_MZONE,0,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,g,g:GetCount(),0,0)
end
function c19454008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
