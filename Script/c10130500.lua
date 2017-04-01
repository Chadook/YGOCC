--Pendulum Advance
--Keddy was here~
local id,cod=10130500,c10130500
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cod.target)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
end
function cod.cfilter(c)
	local scale=0
	if c:GetSequence()==6 then
		scale=c:GetLeftScale()
	else
		scale=c:GetRightScale()
	end
	return c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(cod.scfilter,c:GetControler(),LOCATION_DECK,0,1,nil,scale)
end
function cod.scfilter(c,scale)
	return c:IsType(TYPE_PENDULUM) and (c:GetLeftScale()==scale or c:GetRightScale()==scale) and not c:IsForbidden()
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c:IsControler(tp) and cod.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cod.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cod.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local scale=0
	local seq=tc:GetSequence()
	if seq==6 then
		scale=tc:GetLeftScale()
	else
		scale=tc:GetRightScale()
	end
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local g=Duel.SelectMatchingCard(tp,cod.scfilter,tp,LOCATION_DECK,0,1,1,nil,scale)
		if g:GetCount()>0 then
			local c=g:GetFirst()
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=c:GetActivateEffect()
			local tep=c:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		end
	end
end