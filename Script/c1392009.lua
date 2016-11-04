--Shadowbrave Scorn
function c1392009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c1392009.condition)
	e1:SetTarget(c1392009.target)
	e1:SetOperation(c1392009.activate)
	c:RegisterEffect(e1)
end
function c1392009.filter(c)
	return c:IsFaceup() and c:IsCode(1392002)
end
function c1392009.check()
	return Duel.IsExistingMatchingCard(c1392009.filter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(1392002)
end
function c1392009.condition(e,tp,eg,ep,ev,re,r,rp)
	return c1392009.check()
end
function c1392009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1392009.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
