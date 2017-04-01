--Corroding Pendulum Shark Zombie
function c1013033.initial_effect(c)
	--Pendulum Set
	aux.EnablePendulumAttribute(c)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013033,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,1013033)
	e2:SetTarget(c1013033.thtg)
	e2:SetOperation(c1013033.thop)
	c:RegisterEffect(e2)
	--Destroy Monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1013033,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,1014033)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c1013033.destg)
	e3:SetOperation(c1013033.desop)
	c:RegisterEffect(e3)
end
function c1013033.thfilter(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function c1013033.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c1013033.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1013033.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1013033.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1013033.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c1013033.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c1013033.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1013033.desfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c1013033.desfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c1013033.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c1013033.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,1,0,0)
end
function c1013033.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local c=e:GetHandler()
	local atk=0
	if g1:GetFirst():IsRelateToEffect(e) then
		local ac=g1:GetFirst():GetTextAttack()
		if ac>0 then
			atk=atk+(ac/2)
		end
		Duel.Destroy(g1,REASON_EFFECT)
	end
	if g2:GetFirst():IsRelateToEffect(e) then
		Duel.Destroy(g2,REASON_EFFECT)
	end
	if atk>0 then
	local g=Duel.GetMatchingGroup(c1013033.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
		end
	end
end		
function c1013033.cfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_WATER))
end