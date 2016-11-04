--Fantasia Knight Parade
function c71473115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71473115.target)
	e1:SetOperation(c71473115.activate)
	c:RegisterEffect(e1)
end
function c71473115.filter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c71473115.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsSetCard(0x1C1D)
end
function c71473115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c71473115.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectTarget(tp,c71473115.cfilter,tp,LOCATION_EXTRA,0,1,2,nil)
end
function c71473115.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if tc1 then
		Duel.Destroy(tc1,REASON_EFFECT)
	end
	if tc2 then
		Duel.Destroy(tc2,REASON_EFFECT)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
		tc=g:GetNext()
	end
end