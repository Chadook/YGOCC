--Velocity Spin
function c41880138.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c41880138.target)
	e1:SetOperation(c41880138.activate)
	c:RegisterEffect(e1)
end
function c41880138.dfilter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsSetCard(0x445)
end
function c41880138.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c41880138.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c41880138.dfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c41880138.sfilter,tp,0,LOCATION_SZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c41880138.sfilter,tp,0,LOCATION_SZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
	Duel.SetChainLimit(c41880138.chlimit)
end
function c41880138.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	if g:GetCount()>0 and g:Filter(Card.IsRelateToEffect,nil,e) and	Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,c41880138.dfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsFaceup() and tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
end
function c41880138.chlimit(e,ep,tp)
	local ex,g=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	return tp==ep or not g:IsContains(e:GetHandler())
end